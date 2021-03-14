module.exports = {
  "overrides": [
    {
      "files": ["*.ts", "*.tsx"],
      "extends": [
        "plugin:react/recommended",
        "plugin:@typescript-eslint/recommended",
        "prettier", // eslint-config-prettier
        "plugin:prettier/recommended"
      ],
      "plugins": [
        "react",
        "prettier",
        "@typescript-eslint",
        "react-hooks"
      ],
      "rules": {
        "@typescript-eslint/no-unused-vars": "error",
        "@typescript-eslint/no-explicit-any": "off",
        "@typescript-eslint/explicit-module-boundary-types": "off",
        "react-hooks/rules-of-hooks": "error",
        "react-hooks/exhaustive-deps": "warn",
        "react/prop-types": "error",
        "@typescript-eslint/no-empty-function": "off",
        "react/display-name": "off"
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
      },
      "settings": {
        "react": {
          "pragma": "React",
          "version": "detect"
        }
      }        
    }
  ],
  "parser": "@typescript-eslint/parser",
}
