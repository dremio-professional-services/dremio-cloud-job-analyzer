#!/usr/bin/python
import os
import requests
import sys
import time
import yaml
import argparse
import getpass
import json

_url_prefix = 'v0/projects/'
_catalog_url = '/catalog'
_post_sql_url = "/sql"
_get_job_url = "/job/"

def login(endpoint, org_id, user, password, tls_verify):
    if user:
        login_url = 'ui/login/userpass'
        login_endpoint = endpoint.replace("api", "app")
        headers = {"Content-Type": "application/json"}
        login_data = '{"username": "' + user + '","password": "' + password + '","orgId": "' + org_id + '"}'
        response = requests.request("POST", login_endpoint + login_url, data=login_data, headers=headers, timeout=30, verify=tls_verify)
        if response.status_code != 200:
            sys.exit('Login failure, Status code : {}'.format(response.status_code))
        else:
            authtoken = response.json()['token']
            headers = {"Content-Type": "application/json", "Authorization": "Bearer " + authtoken}
    else:
        headers = {"Content-Type": "application/json", "Authorization": "Bearer " + password}
    return headers

def post_catalog(endpoint, project_id, headers, payload, sleep_time=100, tls_verify=False):
    url = _url_prefix + project_id + _catalog_url
    response = requests.request("POST", endpoint + url, headers=headers, verify=tls_verify, data=payload)
    return response


def query(endpoint, project_id, headers, query, context=None, sleep_time=10, tls_verify=False):
    assert sleep_time > 0
    url = _url_prefix + project_id + _post_sql_url
    job = requests.request("POST", endpoint + url, headers=headers, verify=tls_verify, json={"sql": query, "context": context})
    job_id = job.json()["id"]
    while True:
        state = get_job_status(endpoint, project_id, headers, job_id, tls_verify)
        if state["jobState"] == "COMPLETED":
            status = state["jobState"]
            break
        if state["jobState"] in {"CANCELED", "FAILED"}:
            # todo add info about why did it fail
            if state["errorMessage"]:
                status = state["jobState"] + ": " + state["errorMessage"]
            else:
                status = state["jobState"]
            break
        time.sleep(sleep_time)
    return status


def get_job_status(endpoint, project_id, headers, job_id, tls_verify):
    url = _url_prefix + project_id + _get_job_url + job_id
    response = requests.request("GET", endpoint + url, headers=headers, verify=tls_verify)
    if response.status_code != 200:
        return None
    else:
        return response.json()


def main():
    catalog = [
        "space.JobAnalysis",
        "folder.JobAnalysis.Preparation",
        "folder.JobAnalysis.Business",
        "folder.JobAnalysis.Application"]

    if not os.path.isdir(vds_def_dir):
        raise Exception("Directory " + vds_def_dir + " does not exist")
    if not tls_verify:
        requests.packages.urllib3.disable_warnings(requests.packages.urllib3.exceptions.InsecureRequestWarning)
    headers = login(endpoint, org_id, user, password, tls_verify)
    # Create space and folders from the catalog list
    for item in catalog:
        entity = item.split(".")
        entityType = entity[0]
        for i in range(1, len(entity)):
            entity[i] = '\"' + entity[i] + '\"'
        entityName = ",".join(entity[1:])

        if entityType == "space":
            payload = "{\"entityType\": \"" + entityType + "\", \"name\": " + entityName + "}"
        else:
            #assume entityType is folder
            payload = "{\"entityType\": \"" + entityType + "\", \"path\": [" + entityName + "]}"
        response = post_catalog(endpoint, project_id, headers, payload, tls_verify)
        if response.status_code == 200:
            print(entityType + " " + entityName.replace(",", ".") + " created.")
        elif response.status_code == 409:
            print(entityType + " " + entityName.replace(",", ".") + " already exists, continuing")
        else:
            raise Exception("Unexpected Response Code while creating " + entityType + " " + entityName.replace(",", "\\.") + ": " + response.text)
    sqlFiles = os.listdir(vds_def_dir)
    for sqlFile in sorted(sqlFiles):
        if sqlFile.endswith(".sql"):
            print("Processing SQL file: " + sqlFile)
            str = open(os.path.join(vds_def_dir, sqlFile), 'r').read()
            status = query(endpoint, project_id, headers, str, None, 2, tls_verify)
            print(status)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Script to create the Job Analysis VDSs in Dremio Sonar')
    parser.add_argument('--url', type=str, help='Base Dremio Sonar Endpoint URL, example: https://api.dremio.cloud/', required=True)
    parser.add_argument('--org-id', type=str, help='Dremio Sonar Organization ID', required=True)
    parser.add_argument('--project-id', type=str, help='Dremio Sonar Project ID', required=True)
    parser.add_argument('--user', type=str, help='Dremio user', required=False)
    parser.add_argument('--password', type=str, help='Dremio user password', required=False)
    parser.add_argument('--vds-def-dir', type=str, help='Fully qualified path to set of VDS definitions', required=True)
    parser.add_argument('--tls-verify', action='store_true')

    args = parser.parse_args()
    endpoint = args.url
    org_id = args.org_id
    project_id = args.project_id
    user = args.user
    password = args.password
    if password is None:
        password = getpass.getpass("Enter password:")
    vds_def_dir = args.vds_def_dir
    tls_verify = args.tls_verify
    main()
