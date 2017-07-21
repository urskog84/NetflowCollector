


curl -X POST 'http://localhost:8086/db?u=root&p=root' -d     '{"name": "site_development"}'


  Invoke-WebRequest -Uri 'http://localhost:8086/db?u=root&p=root' -Method Post -Body '{"name": "netflow"}'
  Invoke-WebRequest -Method Get -Uri 'http://192.168.1.161:8086/query/q=SHOW DATABASES"' -UseBasicParsing