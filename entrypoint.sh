#!/bin/bash

cd "${GITHUB_WORKSPACE}"

if [ ${#INPUT_PHPMD_SOURCE_DIFF_FROM_BRANCH} -eq 0 ]; then
  filesToCheck=${INPUT_PHPMD_SOURCE_ARG}
else
  filesToCheck=$(git diff --name-only ${INPUT_PHPMD_SOURCE_DIFF_FROM_BRANCH} | grep php$)
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

# Two issues going on here:
#  i) the warnings issued may correspond to lines that have not been modified
#  ii) the exit code may change if warnings for non-changed lines are disregarded

cat /tmp/phpmd_result.gh

exit $EXIT_CODE
