#!/bin/bash

cd "${GITHUB_WORKSPACE}"

if [ ${#INPUT_PHPMD_SOURCE_DIFF_FROM_BRANCH} -eq 0 ]; then
  filesToCheck=${INPUT_PHPMD_SOURCE_ARG}
else
  filesToCheck=$(git diff --name-only --diff-filter=d \
    `git merge-base ${INPUT_PHPMD_SOURCE_DIFF_FROM_BRANCH} HEAD`..HEAD | grep php$)
  if [ ${#filesToCheck} -eq 0 ]; then
    echo "There are no changed files to check."
    exit 0
  fi
  printf -v filesToCheck "%s," $filesToCheck
fi

/usr/local/bin/php \
  ${INPUT_PHP_ARGS} \
  /usr/local/bin/phpmd.phar \
    ${filesToCheck%,} \
    github \
    ${INPUT_PHPMD_RULESET_ARG} \
    --suffixes php \
    --reportfile /tmp/phpmd_result.gh \
    ${INPUT_PHPMD_OPTIONAL_ARGS}

EXIT_CODE=$?

cat /tmp/phpmd_result.gh

if [ ${INPUT_ALWAYS_PASS} -eq "true" ]; then
  exit 0;
fi

exit $EXIT_CODE
