using System;

namespace WebApplication
{
    public static class GlobalConfig
    {
        public static string ApiUrl =>
            Environment.GetEnvironmentVariable(EnvironmentVariables.ApiServerUrl) ??
            "http://localhost:7071";

        public const string ApiClientName = "ApiClient";

        public static string InstrumentationKey => Resolver.InstrKey;

        private static class Resolver
        {
            public static string InstrKey =>
                Environment.GetEnvironmentVariable(EnvironmentVariables.InstrumentationKey) ??
                string.Empty;
        }
    }
}
