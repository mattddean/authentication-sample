module.exports = {
  "overrides": [
    {
      "files": ["*.ts", "*.tsx"],
      "extends": [
        "eslint:recommended",
        "plugin:@typescript-eslint/eslint-recommended",
        "plugin:@typescript-eslint/recommended",
        "prettier", // eslint-config-prettier
        "plugin:prettier/recommended"
      ],
      "plugins": [
        "prettier",
        "@typescript-eslint",
      ],
      "rules": {
        "@typescript-eslint/no-explicit-any": "off",
        "@typescript-eslint/explicit-module-boundary-types": "off",
        "@typescript-eslint/no-empty-function": "off",
      },
      "parserOptions": {
        "project": "./tsconfig.json",
        "tsconfigRootDir": __dirname,
        "ecmaVersion": 2020,
        "sourceType": "module",
        "ecmaFeatures": {
            "implied-strict": true,
            "modules": true
        }
      }
    }
  ],
  "parser": "@typescript-eslint/parser",
}
