# Repo Maintenance

This repo has two branches:

  * master: API Client Reference Implementation
  * gh-pages: Docco generated documentation, hosted at http://engineering.continuity.net/control_api_reference/


## Release Management

Initial Setup:

```
cd ~
npm install docco
```

Deploy:

```
git checkout master && rake release
```

## Gotchas

Issue: Reference documentation is missing styles or syntax highlighting is broken

Solution: css and/or fonts are out of date, run `git checkout gh-pages && rm -rf docco.css public && cp -a ~/node_modules/docco/resources/parallel/* .` and re-deploy
