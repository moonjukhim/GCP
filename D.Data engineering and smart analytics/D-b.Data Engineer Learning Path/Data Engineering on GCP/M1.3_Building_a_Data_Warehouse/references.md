
### Array (Type:STRING, Mode:REPEATED)

```sql
create table test.array_demo 
as 
(
    select ["current", "previous", "birth"] as address_history
)

select address_history from a
```


### Struct (Type:RECORDE, Mode:NULLABLE)

```sql
create table test.struct_demo 
as (
    select struct("current" as status, "Seoul" as address, "ABCD1234" as postcode) as address_history   
)

select address_history from test.struct_demo
```

### Array of Structs

```sql
create table test.array_of_struct
as (
    select [
        struct("previous" as status, "Seoul" as address, "ABCD1234" as postcode) ,
        struct("current" as status, "Busan" as address, "12345678" as postcode) ,
        struct("birth" as status, "Daejeon" as address, "1234ABCD" as postcode)] as address_history
)

select address_history from test.array_of_struct
```

