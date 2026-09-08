gcloud storage cp -r . $(gcloud composer environments \
describe lab-environment --location us-central1 \
--format="value(config.dagGcsPrefix)")