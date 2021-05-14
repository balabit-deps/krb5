#!/bin/sh

# Copy of: https://git.balabit/syslog-ng-7.0/syslog-ng-pe-modules/-/commit/3fd698ca85add94c24aface3078b429f0e79d13f
# gitlab-ci: git should use credentatios from gitlab
# Gitlab-CI runner provides CA certificate, username and access token to use with
# the current git instance. But scripts generally do not depend on these values,
# but rather that the user has ssh access to the gitlab server.
#
# In order to have such access some user have to expose their private key, which
# kinda works but not the best.  This is an alternative solution, that uses git
# url replace functionality and replaces ssh::// clones with https:// and the
# proper username/access tokens. There is no need to modify tools checking for
# environment variables.
# Signed-off-by: Kokan <kokaipeter@gmail.com>

if [ -z "${CI_JOB_TOKEN}" ] ; then
  echo "This scripts requires CI_JOB_TOKEN environment variable."
  exit 1
fi

if [ -z "${CI_SERVER_TLS_CA_FILE}" ] ; then
  echo "This scripts requires CI_SERVER_TLS_CA_FILE environment variable."
  exit 1
fi

git config --global url."https://gitlab-ci-token:${CI_JOB_TOKEN}@git.balabit/".insteadOf git@git.balabit:
git config --global http.sslCAinfo ${CI_SERVER_TLS_CA_FILE}
