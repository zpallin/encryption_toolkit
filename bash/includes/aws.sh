#!/bin/bash

# aws-vault environments
function vault-stg() {
	aws-vault exec stg -- $@
}
