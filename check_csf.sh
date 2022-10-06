#!/bin/bash
if ! csf -l >& /dev/null; then
    csf -e >& /dev/null
    echo "csf is enable"
fi
    
