#!/bin/bash

echo "::group::openapi-diff"

echo "Get current version of file $CHANGED_FILE, commit ${CURRENT_HASH}"
git show ${CURRENT_HASH}:${changed_file} > ${changed_file}_new.yml
ls ${changed_file}_new.yml

echo "Get previous version of file $CHANGED_FILE, commit ${PREVIOUS_HASH}"
git show ${PREVIOUS_HASH}:${changed_file} > ${changed_file}_old.yml
ls ${changed_file}_old.yml

echo "Show diff"
git diff ${PREVIOUS_HASH} ${CURRENT_HASH} -- ${changed_file}

echo "Check for breaking changes"
java -jar openapi-diff-cli-2.1.0.jar ${changed_file}_old.yml ${changed_file}_new.yml --fail-on-incompatible
if [ $? -ne 0 ]; then
  exit 1
fi

echo "::endgroup::"
