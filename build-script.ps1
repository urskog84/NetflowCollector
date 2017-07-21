# Docker build
docker-compose down

# Docker-compose rm $(docker-compose ps -q)
docker-compose build

# Docker-comose start services
docker-compose up -d

# Create Database netflow in influxdb
Write-Host "Create Database netflow in influxdb" -ForegroundColor Yellow
Invoke-WebRequest -Uri "http://localhost:8086/query" -Method Post -Body @{q='CREATE DATABASE netflow'}

Start-Sleep -Seconds 5

# Create Datasorces in Grafana
Write-Host "Create Datasorces in Grafana" -ForegroundColor Yellow
$basicAuthValue = @{authorization = 'Basic YWRtaW46YWRtaW4='}

$jsonDataSource = @"
{
    "name": "netflow",
    "type": "influxdb",
    "access": "direct",
    "url": "http://localhost:8086",
    "database": "netflow",
    "isDefault": true,
    "basicAuth": false
}
"@

Invoke-WebRequest -Uri "http://localhost:3000/api/datasources" -Method Post -Body $jsonDataSource -Headers $basicAuthValue -ContentType 'application/json'



# Create Dashbord in Grafana 
Write-Host "Create Dashbord in Grafana " -ForegroundColor Yellow

$jsonDashboard = @"
{
  "dashboard": {
    "id": null,
    "title": "Netflow",
    "tags": [ "" ],
    "timezone": "browser",
    "refresh": "30s",
    "rows": [
      {
      "collapse": false,
      "height": "250px",
      "panels": [
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": "netflow",
          "fill": 1,
          "height": "400",
          "id": 1,
          "legend": {
            "avg": false,
            "current": false,
            "max": false,
            "min": false,
            "show": true,
            "total": false,
            "values": false
          },
          "lines": true,
          "linewidth": 1,
          "links": [],
          "nullPointMode": "null",
          "percentage": false,
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [],
          "spaceLength": 10,
          "span": 12,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "dsType": "influxdb",
              "groupBy": [],
              "measurement": "netflow.event",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "A",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "in_bytes"
                    ],
                    "type": "field"
                  }
                ]
              ],
              "tags": []
            }
          ],
          "thresholds": [],
          "timeFrom": null,
          "timeShift": null,
          "title": "in_bytes",
          "tooltip": {
            "shared": true,
            "sort": 0,
            "value_type": "individual"
          },
          "type": "graph",
          "xaxis": {
            "buckets": null,
            "mode": "time",
            "name": null,
            "show": true,
            "values": []
          },
          "yaxes": [
            {
              "format": "short",
              "label": null,
              "logBase": 1,
              "max": null,
              "min": null,
              "show": true
            },
            {
              "format": "short",
              "label": null,
              "logBase": 1,
              "max": null,
              "min": null,
              "show": true
            }
          ]
        }
      ],
      "repeat": null,
      "repeatIteration": null,
      "repeatRowId": null,
      "showTitle": false,
      "title": "Dashboard Row",
      "titleSize": "h6"
    }
    ],
    "schemaVersion": 6,
    "version": 0
  },
  "overwrite": false
}
"@

Invoke-WebRequest -Uri "http://localhost:3000/api/dashboards/db" -Method Post -Body $jsonDashboard -Headers $basicAuthValue -ContentType 'application/json'

# Docker-compose restart fluentd 
docker-compose restart fluentd