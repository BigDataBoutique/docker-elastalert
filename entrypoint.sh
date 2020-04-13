set -e

mkdir -p /etc/elastalert/
mkdir -p /etc/elastalert-rules/
envsubst < config.yaml > "/etc/elastalert/config.yaml";
for r in rules/*; do
  envsubst < "$r" > "/etc/elastalert-$r";
done

cd /etc/elastalert
elastalert-create-index
python3 -m elastalert.elastalert --verbose
