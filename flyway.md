```bash
docker run --rm --network=host \
-v /Users/daddy/Desktop/codes/kastle/db-migrations/sql:/flyway/sql \
boxfuse/flyway \
-user=kastle_user \
-url=jdbc:postgresql://localhost:5432/kastle \
migrate
```
