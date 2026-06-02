// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

package org.apache.doris.nereids.pattern.generator;

import org.apache.doris.nereids.JavaLexer;
import org.apache.doris.nereids.JavaParser;
import org.apache.doris.nereids.pattern.generator.javaast.TypeDeclaration;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.DefaultErrorStrategy;
import org.antlr.v4.runtime.InputMismatchException;
import org.antlr.v4.runtime.Parser;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.atn.PredictionMode;
import org.antlr.v4.runtime.misc.ParseCancellationException;
import org.apache.commons.io.FileUtils;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.stream.Collectors;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;

/**
 * Standalone main class to generate pattern files without annotation processing.
 * This replaces the 3-phase Maven compilation approach for Bazel builds.
 *
 * Usage: PatternGeneratorMain <source-dirs> <output-dir>
 *   source-dirs: comma-separated list of directories containing Java source files
 *   output-dir: directory where generated Java files will be written
 *
 * Generates:
 *   - GeneratedMemoPatterns.java
 *   - GeneratedPlanPatterns.java
 *   - GeneratedExpressionRelations.java
 *   - GeneratedPlanRelations.java
 */
public class PatternGeneratorMain {

    public static void main(String[] args) throws Exception {
        if (args.length < 2) {
            System.err.println("Usage: PatternGeneratorMain <source-dirs> <output-dir>");
            System.err.println("  source-dirs: comma-separated list of directories containing Java source files");
            System.err.println("  output-dir: directory where generated Java files will be written");
            System.exit(1);
        }

        String sourceDirs = args[0];
        String outputDir = args[1];

        List<File> paths = Arrays.stream(sourceDirs.split(","))
                .map(String::trim)
                .filter(path -> !path.isEmpty())
                .map(File::new)
                .collect(Collectors.toList());

        File outDir = new File(outputDir);
        if (!outDir.exists()) {
            outDir.mkdirs();
        }

        // Parse all Java files
        List<File> javaFiles = findJavaFiles(paths);
        System.out.println("Found " + javaFiles.size() + " Java files to analyze");

        JavaAstAnalyzer javaAstAnalyzer = new JavaAstAnalyzer();
        int parsed = 0;
        for (File file : javaFiles) {
            try {
                List<TypeDeclaration> asts = parseJavaFile(file);
                javaAstAnalyzer.addAsts(asts);
                parsed++;
            } catch (Exception e) {
                System.err.println("Warning: Failed to parse " + file.getPath() + ": " + e.getMessage());
            }
        }
        System.out.println("Successfully parsed " + parsed + " files");

        javaAstAnalyzer.analyze();

        // Generate ExpressionRelations
        generateExpressionRelations(javaAstAnalyzer, outDir);

        // Generate PlanRelations
        generatePlanRelations(javaAstAnalyzer, outDir);

        // Generate MemoPatterns and PlanPatterns
        PlanPatternGeneratorAnalyzer patternGeneratorAnalyzer = new PlanPatternGeneratorAnalyzer(javaAstAnalyzer);
        generatePlanPatterns("GeneratedMemoPatterns", "MemoPatterns", true, patternGeneratorAnalyzer, outDir);
        generatePlanPatterns("GeneratedPlanPatterns", "PlanPatterns", false, patternGeneratorAnalyzer, outDir);

        System.out.println("Pattern generation completed successfully");
    }

    private static void generateExpressionRelations(JavaAstAnalyzer analyzer, File outDir) throws IOException {
        Set<String> superExpressions = findSuperExpression(analyzer);
        Map<String, Set<String>> childrenNameMap = analyzer.getChildrenNameMap();
        Map<String, Set<String>> parentNameMap = analyzer.getParentNameMap();
        String code = generateExpressionRelationsCode(childrenNameMap, parentNameMap, superExpressions);
        writeFile(new File(outDir, "GeneratedExpressionRelations.java"), code);
        System.out.println("Generated: GeneratedExpressionRelations.java");
    }

    private static void generatePlanRelations(JavaAstAnalyzer analyzer, File outDir) throws IOException {
        Set<String> superPlans = findSuperPlan(analyzer);
        Map<String, Set<String>> childrenNameMap = analyzer.getChildrenNameMap();
        Map<String, Set<String>> parentNameMap = analyzer.getParentNameMap();
        String code = generatePlanRelationsCode(childrenNameMap, parentNameMap, superPlans);
        writeFile(new File(outDir, "GeneratedPlanRelations.java"), code);
        System.out.println("Generated: GeneratedPlanRelations.java");
    }

    private static void generatePlanPatterns(String className, String parentClassName, boolean isMemoPattern,
            PlanPatternGeneratorAnalyzer patternGeneratorAnalyzer, File outDir) throws IOException {
        String generatePatternCode = patternGeneratorAnalyzer.generatePatterns(
                className, parentClassName, isMemoPattern);
        writeFile(new File(outDir, className + ".java"), generatePatternCode);
        System.out.println("Generated: " + className + ".java");
    }

    private static void writeFile(File file, String content) throws IOException {
        if (file.exists()) {
            file.delete();
        }
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }
        try (BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(file))) {
            bufferedWriter.write(content);
        }
    }

    private static List<File> findJavaFiles(List<File> dirs) {
        List<File> files = new ArrayList<>();
        for (File dir : dirs) {
            if (dir.exists() && dir.isDirectory()) {
                files.addAll(FileUtils.listFiles(dir, new String[]{"java"}, true));
            } else {
                System.err.println("Warning: Directory does not exist: " + dir.getPath());
            }
        }
        return files;
    }

    private static List<TypeDeclaration> parseJavaFile(File javaFile) throws IOException {
        String javaCodeString = FileUtils.readFileToString(javaFile, StandardCharsets.UTF_8);
        JavaLexer lexer = new JavaLexer(CharStreams.fromString(javaCodeString));

        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        JavaParser parser = new JavaParser(tokenStream);
        parser.setErrorHandler(new DefaultErrorStrategy() {
            @Override
            public Token recoverInline(Parser recognizer) throws RecognitionException {
                if (nextTokensContext == null) {
                    throw new InputMismatchException(recognizer);
                } else {
                    throw new InputMismatchException(recognizer, nextTokensState, nextTokensContext);
                }
            }
        });

        ParserRuleContext tree;
        try {
            parser.getInterpreter().setPredictionMode(PredictionMode.SLL);
            tree = parser.compilationUnit();
        } catch (ParseCancellationException ex) {
            tokenStream.seek(0);
            parser.reset();
            parser.getInterpreter().setPredictionMode(PredictionMode.LL);
            tree = parser.compilationUnit();
        }

        return new JavaAstBuilder().build(tree);
    }

    // =========================================================================
    // ExpressionRelations generation (extracted from ExpressionTypeMappingGenerator)
    // =========================================================================

    private static final Set<String> EXPRESSION_FORBIDDEN_CLASS = Sets.newHashSet(
            "org.apache.doris.nereids.trees.expressions.functions.ExpressionTrait",
            "org.apache.doris.nereids.trees.expressions.shape.LeafExpression",
            "org.apache.doris.nereids.trees.expressions.shape.UnaryExpression",
            "org.apache.doris.nereids.trees.expressions.shape.BinaryExpression",
            "org.apache.doris.nereids.trees.expressions.functions.AlwaysNullable",
            "org.apache.doris.nereids.trees.expressions.functions.AlwaysNotNullable",
            "org.apache.doris.nereids.trees.expressions.functions.PropagateNullLiteral",
            "org.apache.doris.nereids.trees.expressions.typecoercion.ImplicitCastInputTypes",
            "org.apache.doris.nereids.trees.expressions.functions.ExplicitlyCastableSignature",
            "org.apache.doris.nereids.trees.expressions.functions.Function",
            "org.apache.doris.nereids.trees.expressions.functions.FunctionTrait",
            "org.apache.doris.nereids.trees.expressions.functions.ComputeSignature",
            "org.apache.doris.nereids.trees.expressions.functions.scalar.ScalarFunction",
            "org.apache.doris.nereids.trees.expressions.typecoercion.ExpectsInputTypes",
            "org.apache.doris.nereids.trees.expressions.functions.ComputeNullable",
            "org.apache.doris.nereids.trees.expressions.functions.PropagateNullable"
    );

    private static Set<String> findSuperExpression(JavaAstAnalyzer analyzer) {
        Map<String, Set<String>> parentNameMap = analyzer.getParentNameMap();
        Map<String, Set<String>> childrenNameMap = analyzer.getChildrenNameMap();
        Set<String> superExpressions = Sets.newLinkedHashSet();
        for (Entry<String, Set<String>> entry : childrenNameMap.entrySet()) {
            String parentName = entry.getKey();
            Set<String> childrenNames = entry.getValue();

            if (parentName.startsWith("org.apache.doris.nereids.trees.expressions.")) {
                for (String childrenName : childrenNames) {
                    Set<String> parentNames = parentNameMap.get(childrenName);
                    if (parentNames != null
                            && parentNames.contains("org.apache.doris.nereids.trees.expressions.Expression")) {
                        superExpressions.add(parentName);
                        break;
                    }
                }
            }
        }
        return superExpressions;
    }

    private static String generateExpressionRelationsCode(Map<String, Set<String>> childrenNameMap,
            Map<String, Set<String>> parentNameMap, Set<String> superExpressions) {
        String generateCode
                = "// Licensed to the Apache Software Foundation (ASF) under one\n"
                + "// or more contributor license agreements.  See the NOTICE file\n"
                + "// distributed with this work for additional information\n"
                + "// regarding copyright ownership.  The ASF licenses this file\n"
                + "// to you under the Apache License, Version 2.0 (the\n"
                + "// \"License\"); you may not use this file except in compliance\n"
                + "// with the License.  You may obtain a copy of the License at\n"
                + "//\n"
                + "//   http://www.apache.org/licenses/LICENSE-2.0\n"
                + "//\n"
                + "// Unless required by applicable law or agreed to in writing,\n"
                + "// software distributed under the License is distributed on an\n"
                + "// \"AS IS\" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY\n"
                + "// KIND, either express or implied.  See the License for the\n"
                + "// specific language governing permissions and limitations\n"
                + "// under the License.\n"
                + "\n"
                + "package org.apache.doris.nereids.pattern;\n"
                + "\n"
                + "import org.apache.doris.nereids.trees.expressions.Expression;\n"
                + "\n"
                + "import com.google.common.collect.ImmutableMap;\n"
                + "import com.google.common.collect.ImmutableSet;\n"
                + "\n"
                + "import java.util.Map;\n"
                + "import java.util.Set;\n"
                + "\n";
        generateCode += "/** GeneratedExpressionRelations */\npublic class GeneratedExpressionRelations {\n";
        String childrenClassesGenericType = "<Class<?>, Set<Class<? extends Expression>>>";
        generateCode +=
                "    public static final Map" + childrenClassesGenericType + " CHILDREN_CLASS_MAP;\n\n";
        generateCode +=
                "    static {\n"
              + "        ImmutableMap.Builder" + childrenClassesGenericType + " childrenClassesBuilder\n"
              + "                = ImmutableMap.builderWithExpectedSize(" + childrenNameMap.size() + ");\n";

        for (String superExpression : superExpressions) {
            if (EXPRESSION_FORBIDDEN_CLASS.contains(superExpression)) {
                continue;
            }

            Set<String> childrenClasseSet = childrenNameMap.get(superExpression)
                    .stream()
                    .filter(childClass -> parentNameMap.get(childClass)
                            .contains("org.apache.doris.nereids.trees.expressions.Expression")
                    )
                    .collect(Collectors.toSet());

            List<String> childrenClasses = Lists.newArrayList(childrenClasseSet);
            Collections.sort(childrenClasses, Comparator.naturalOrder());

            String childClassesString = childrenClasses.stream()
                    .map(childClass -> "                    " + childClass + ".class")
                    .collect(Collectors.joining(",\n"));
            generateCode += "        childrenClassesBuilder.put(\n                " + superExpression
                    + ".class,\n                ImmutableSet.<Class<? extends Expression>>of(\n" + childClassesString
                    + "\n                )\n        );\n\n";
        }

        generateCode += "        CHILDREN_CLASS_MAP = childrenClassesBuilder.build();\n";
        return generateCode + "    }\n}\n";
    }

    // =========================================================================
    // PlanRelations generation (extracted from PlanTypeMappingGenerator)
    // =========================================================================

    private static Set<String> findSuperPlan(JavaAstAnalyzer analyzer) {
        Map<String, Set<String>> parentNameMap = analyzer.getParentNameMap();
        Map<String, Set<String>> childrenNameMap = analyzer.getChildrenNameMap();
        Set<String> superPlans = Sets.newLinkedHashSet();
        for (Entry<String, Set<String>> entry : childrenNameMap.entrySet()) {
            String parentName = entry.getKey();
            Set<String> childrenNames = entry.getValue();

            if (parentName.startsWith("org.apache.doris.nereids.trees.plans.")) {
                for (String childrenName : childrenNames) {
                    Set<String> parentNames = parentNameMap.get(childrenName);
                    if (parentNames != null
                            && parentNames.contains("org.apache.doris.nereids.trees.plans.Plan")) {
                        superPlans.add(parentName);
                        break;
                    }
                }
            }
        }
        return superPlans;
    }

    private static String generatePlanRelationsCode(Map<String, Set<String>> childrenNameMap,
            Map<String, Set<String>> parentNameMap, Set<String> superPlans) {
        String generateCode
                = "// Licensed to the Apache Software Foundation (ASF) under one\n"
                + "// or more contributor license agreements.  See the NOTICE file\n"
                + "// distributed with this work for additional information\n"
                + "// regarding copyright ownership.  The ASF licenses this file\n"
                + "// to you under the Apache License, Version 2.0 (the\n"
                + "// \"License\"); you may not use this file except in compliance\n"
                + "// with the License.  You may obtain a copy of the License at\n"
                + "//\n"
                + "//   http://www.apache.org/licenses/LICENSE-2.0\n"
                + "//\n"
                + "// Unless required by applicable law or agreed to in writing,\n"
                + "// software distributed under the License is distributed on an\n"
                + "// \"AS IS\" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY\n"
                + "// KIND, either express or implied.  See the License for the\n"
                + "// specific language governing permissions and limitations\n"
                + "// under the License.\n"
                + "\n"
                + "package org.apache.doris.nereids.pattern;\n"
                + "\n"
                + "import org.apache.doris.nereids.trees.plans.Plan;\n"
                + "\n"
                + "import com.google.common.collect.ImmutableMap;\n"
                + "import com.google.common.collect.ImmutableSet;\n"
                + "\n"
                + "import java.util.Map;\n"
                + "import java.util.Set;\n"
                + "\n";
        generateCode += "/** GeneratedPlanRelations */\npublic class GeneratedPlanRelations {\n";
        String childrenClassesGenericType = "<Class<?>, Set<Class<? extends Plan>>>";
        generateCode +=
                "    public static final Map" + childrenClassesGenericType + " CHILDREN_CLASS_MAP;\n\n";
        generateCode +=
                "    static {\n"
              + "        ImmutableMap.Builder" + childrenClassesGenericType + " childrenClassesBuilder\n"
              + "                = ImmutableMap.builderWithExpectedSize(" + childrenNameMap.size() + ");\n";

        for (String superPlan : superPlans) {
            Set<String> childrenClasseSet = childrenNameMap.get(superPlan)
                    .stream()
                    .filter(childClass -> parentNameMap.get(childClass)
                            .contains("org.apache.doris.nereids.trees.plans.Plan")
                    )
                    .collect(Collectors.toSet());

            List<String> childrenClasses = Lists.newArrayList(childrenClasseSet);
            Collections.sort(childrenClasses, Comparator.naturalOrder());

            String childClassesString = childrenClasses.stream()
                    .map(childClass -> "                    " + childClass + ".class")
                    .collect(Collectors.joining(",\n"));
            generateCode += "        childrenClassesBuilder.put(\n                " + superPlan
                    + ".class,\n                ImmutableSet.<Class<? extends Plan>>of(\n" + childClassesString
                    + "\n                )\n        );\n\n";
        }

        generateCode += "        CHILDREN_CLASS_MAP = childrenClassesBuilder.build();\n";
        return generateCode + "    }\n}\n";
    }
}
