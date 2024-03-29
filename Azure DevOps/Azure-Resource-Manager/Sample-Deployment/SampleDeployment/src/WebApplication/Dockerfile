#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS base
WORKDIR /app
EXPOSE 8081
ENV ASPNETCORE_URLS=https://+:8081
RUN dotnet dev-certs https -ep ${HOME}/.aspnet/https/aspnetapp.pfx -p Passw@rd+1

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["src/WebApplication/WebApplication.csproj", "src/WebApplication/"]
RUN dotnet restore "src/WebApplication/WebApplication.csproj"
COPY . .
WORKDIR "/src/src/WebApplication"
RUN dotnet build "WebApplication.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WebApplication.csproj" -c Release -o /app/publish
RUN dotnet tool install --tool-path /dotnet-tool dotnet-sos
RUN dotnet tool install --tool-path /dotnet-tool dotnet-trace
RUN dotnet tool install --tool-path /dotnet-tool dotnet-dump
RUN dotnet tool install --tool-path /dotnet-tool dotnet-counters

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
COPY --from=publish /dotnet-tool /opt/dotnet-tool
ENV PATH="/opt/dotnet-tool:${PATH}"
ENTRYPOINT ["dotnet", "WebApplication.dll"]