import globals from "globals";
import pluginJs from "@eslint/js";

/** @type {import('eslint').Linter.Config[]} */
export default [
  // 1. Tell ESLint how to handle your actual backend JS files
  {
    files: ["src/**/*.js", "index.js", "server.js"],
    languageOptions: {
      globals: {
        ...globals.node, // Gives access to 'require', 'module', 'process', etc.
      },
      sourceType: "commonjs", // Ensures your backend code parses correctly
    },
    rules: {
      "no-undef": "error",
      "no-unused-vars": "warn",
    }
  },
  
  // 2. Separate rule for the configuration file itself so it doesn't crash on 'import'
  {
    files: ["eslint.config.mjs"],
    languageOptions: {
      sourceType: "module",
    }
  }
];
