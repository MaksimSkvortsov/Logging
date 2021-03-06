FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["Logging/Logging.csproj", "Logging/"]
RUN dotnet restore "Logging/Logging.csproj"
COPY . .
WORKDIR "/src/Logging"
RUN dotnet build "Logging.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "Logging.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
COPY ["deployment-azure.yaml", "deployment-azure.yaml"]
ENTRYPOINT ["dotnet", "Logging.dll"]
