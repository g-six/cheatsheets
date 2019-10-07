#!/bin/bash
aws cloudfront create-invalidation --invalidation-batch file://inv.json --distribution-id EKPQHQWLSZRB4