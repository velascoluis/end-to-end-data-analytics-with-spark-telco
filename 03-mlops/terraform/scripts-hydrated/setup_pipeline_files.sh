#!/bin/sh
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#........................................................................
# Purpose: Download KFP files to local
#........................................................................



GCLOUD_BIN=`which gcloud`
GSUTIL_BIN=`which gsutil`


ERROR_EXIT=1



MLOPS_DIR="mlops"
PROJECT_ID=`"${GCLOUD_BIN}" config list --format "value(core.project)" 2>/dev/null`
REGION=`"${GCLOUD_BIN}" compute project-info describe --project ${PROJECT_ID} --format "value(commonInstanceMetadata.google-compute-default-region)" 2>/dev/null`
if [[ "${REGION}" == "" ]]; then
  REGION="us-central1"
fi
BUCKET_NAME="s8s_code_bucket-${PROJECT_ID}"
BUCKET_URI="gs://${BUCKET_NAME}"


if [ ! "${CLOUD_SHELL}" = true ]; then
    echo "This script needs to run on Google Cloud Shell. Exiting ..."
    exit ${ERROR_EXIT}
fi


mkdir -p "${MLOPS_DIR}"
"${GSUTIL_BIN}" cp ${BUCKET_URI}/kfp_pipeline.py "${MLOPS_DIR}"
if [ ! "${?}" -eq 0 ]; then
        LOG_DATE=`date`
        echo "Unable to copy kfp pipeline file .."
        exit ${ERROR_EXIT}
fi

"${GSUTIL_BIN}" cp ${BUCKET_URI}/requirements*.txt "${MLOPS_DIR}"
if [ ! "${?}" -eq 0 ]; then
        LOG_DATE=`date`
        echo "Unable to copy requirements files .."
        exit ${ERROR_EXIT}
fi

"${GSUTIL_BIN}" cp ${BUCKET_URI}/launch_kfp_pipeline.sh "${MLOPS_DIR}"
if [ ! "${?}" -eq 0 ]; then
        LOG_DATE=`date`
        echo "Unable to copy launch kfp pipeline file .."
        exit ${ERROR_EXIT}
fi

"${GSUTIL_BIN}" cp ${BUCKET_URI}/get_predictions.py "${MLOPS_DIR}"
if [ ! "${?}" -eq 0 ]; then
        LOG_DATE=`date`
        echo "Unable to copy  get predictions file .."
        exit ${ERROR_EXIT}
fi

"${GSUTIL_BIN}" cp ${BUCKET_URI}/launch_get_predictions.sh "${MLOPS_DIR}"
if [ ! "${?}" -eq 0 ]; then
        LOG_DATE=`date`
        echo "Unable to copy launch get predictions file .."
        exit ${ERROR_EXIT}
fi

"${GSUTIL_BIN}" cp ${BUCKET_URI}/schema.json "${MLOPS_DIR}"
if [ ! "${?}" -eq 0 ]; then
        LOG_DATE=`date`
        echo "Unable to copy schema file .."
        exit ${ERROR_EXIT}
fi



echo "###########################################################################################"
echo "${LOG_DATE} Execution finished! ..."
