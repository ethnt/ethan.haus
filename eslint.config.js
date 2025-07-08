import eslintPluginAstro from "eslint-plugin-astro";
import eslintConfigPrettier from "eslint-config-prettier";

export default [
  eslintConfigPrettier,
  ...eslintPluginAstro.configs.recommended,
  {
    rules: {}
  }
];
