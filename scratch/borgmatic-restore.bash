sudo systemd-run --wait --pipe --collect --quiet --unit="borgmatic-restore" \
    --property=LoadCredentialEncrypted=borgmatic:/etc/credstore.encrypted/borgmatic/ \
    --property=LoadCredentialEncrypted=centraldb:/etc/credstore.encrypted/centraldb/ \
    --property=LoadCredentialEncrypted=borgmatic.pw \
    borgmatic list -c /etc/borgmatic.d/20-n8n.yaml \
    --match-archives "*" \
    --json \
    2>&1 | awk '/\[\{/ {print}'
