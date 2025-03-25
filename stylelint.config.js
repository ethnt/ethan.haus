/** @type {import("stylelint").Config} */
export default {
  extends: ["stylelint-config-standard", "stylelint-config-html"],
  rules: {
    "custom-property-pattern": [
      "^([a-z][a-z0-9]*)((-|--)[a-z0-9]+)*$",
      {
        message: "Expected custom property name to be double kebab-case",
      },
    ],
  },
};
