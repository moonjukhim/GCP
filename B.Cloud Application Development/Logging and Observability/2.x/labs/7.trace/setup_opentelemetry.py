import os

from opentelemetry.sdk.resources import SERVICE_INSTANCE_ID, SERVICE_NAME, Resource

from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

from opentelemetry import metrics
from opentelemetry.exporter.otlp.proto.http.metric_exporter import OTLPMetricExporter
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader

# [START opentelemetry_instrumentation_setup_opentelemetry]
resource = Resource.create(attributes={
    # Use the PID as the service.instance.id to avoid duplicate timeseries
    # from different Gunicorn worker processes.
    SERVICE_INSTANCE_ID: f"worker-{os.getpid()}",
})

traceProvider = TracerProvider(resource=resource)
processor = BatchSpanProcessor(OTLPSpanExporter())
traceProvider.add_span_processor(processor)
trace.set_tracer_provider(traceProvider)

reader = PeriodicExportingMetricReader(
    OTLPMetricExporter()
)
meterProvider = MeterProvider(metric_readers=[reader], resource=resource)
metrics.set_meter_provider(meterProvider)
# [END opentelemetry_instrumentation_setup_opentelemetry]