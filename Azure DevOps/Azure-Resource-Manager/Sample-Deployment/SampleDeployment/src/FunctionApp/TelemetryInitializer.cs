using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.Extensibility;

namespace FunctionApp
{
    internal class TelemetryInitializer : ITelemetryInitializer
    {
        private readonly string _roleName;

        public TelemetryInitializer()
        {
            _roleName = "FunctionApp";
        }

        public void Initialize(ITelemetry telemetry)
        {
            telemetry.Context.Cloud.RoleName = _roleName;
            telemetry.Context.Cloud.RoleInstance = _roleName;
        }
    }
}
