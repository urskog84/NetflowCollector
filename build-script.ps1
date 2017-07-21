# Docker build
docker-compose.exe rm $(docker-compose.exe ps -q)

docker-compose build 

docker-compose up


## Crreate Database in INFLUX

Invoke-WebRequest -Uri "http://localhost:8086/query" -Method Post -Body @{q='CREATE DATABASE netflow'}

## Create Datasorces in Grafana
$basicAuthValue = @{authorization = 'Basic YWRtaW46YWRtaW4='}

$json = @"
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


#POST /api/datasources

Invoke-WebRequest -Uri "http://localhost:3000/api/datasources" -Method Post -Body $json -Headers $basicAuthValue -ContentType 'application/json'

# Create Dashbord

$dashjson = @"
{
  "dashboard": {
    "id": null,
    "title": "Netflow",
    "tags": [ "templated" ],
    "timezone": "browser",
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

Invoke-WebRequest -Uri "http://localhost:3000/api/dashboards/db" -Method Post -Body $dashjson -Headers $basicAuthValue -ContentType 'application/json'

docker-compose restart fluentd