# Servers

## nube1
### nginx
- stel.codes
  - static
- preview.stel.codes
  -static
  - password protected
- cms.stel.codes
  - port proxy to directus cms nodejs app
- news.stel.codes
  - port proxy to functional-news clojure app

### postgres
#### Roles
```
postgres=# \du
                                        List of roles
      Role name      |                         Attributes                         | Member of 
---------------------+------------------------------------------------------------+-----------
 dev_blog_directus   |                                                            | {}
 functional_news_app |                                                            | {}
 postgres            | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 static_site_builder |                                                            | {}
 stel                | Superuser                                                  | {}
```
#### Databases
```
 psql --list           
                                           List of databases
       Name        |  Owner   | Encoding |   Collate   |    Ctype    |        Access privileges         
-------------------+----------+----------+-------------+-------------+----------------------------------
 dev_blog          | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres                    +
                   |          |          |             |             | postgres=CTc/postgres           +
                   |          |          |             |             | dev_blog_directus=CTc/postgres  +
                   |          |          |             |             | stel=CTc/postgres
 dev_blog_directus | stel     | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 functional_news   | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/postgres                    +
                   |          |          |             |             | postgres=CTc/postgres           +
                   |          |          |             |             | functional_news_app=CTc/postgres
 postgres          | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0         | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres                     +
                   |          |          |             |             | postgres=CTc/postgres
 template1         | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres                     +
                   |          |          |             |             | postgres=CTc/postgres
 test              | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
(7 rows)

```
##### `dev_blog`
```
dev_blog-# \d
                          List of relations
 Schema |            Name             |   Type   |       Owner       
--------+-----------------------------+----------+-------------------
 public | blog_posts                  | table    | dev_blog_directus
 public | blog_posts_id_seq           | sequence | dev_blog_directus
 public | coding_projects             | table    | dev_blog_directus
 public | coding_projects_id_seq      | sequence | dev_blog_directus
 public | directus_activity           | table    | dev_blog_directus
 public | directus_activity_id_seq    | sequence | dev_blog_directus
 public | directus_collections        | table    | dev_blog_directus
 public | directus_fields             | table    | dev_blog_directus
 public | directus_fields_id_seq      | sequence | dev_blog_directus
 public | directus_files              | table    | dev_blog_directus
 public | directus_folders            | table    | dev_blog_directus
 public | directus_migrations         | table    | dev_blog_directus
 public | directus_permissions        | table    | dev_blog_directus
 public | directus_permissions_id_seq | sequence | dev_blog_directus
 public | directus_presets            | table    | dev_blog_directus
 public | directus_presets_id_seq     | sequence | dev_blog_directus
 public | directus_relations          | table    | dev_blog_directus
 public | directus_relations_id_seq   | sequence | dev_blog_directus
 public | directus_revisions          | table    | dev_blog_directus
 public | directus_revisions_id_seq   | sequence | dev_blog_directus
 public | directus_roles              | table    | dev_blog_directus
 public | directus_sessions           | table    | dev_blog_directus
 public | directus_settings           | table    | dev_blog_directus
 public | directus_settings_id_seq    | sequence | dev_blog_directus
 public | directus_users              | table    | dev_blog_directus
 public | directus_webhooks           | table    | dev_blog_directus
 public | directus_webhooks_id_seq    | sequence | dev_blog_directus
 public | educational_media           | table    | dev_blog_directus
 public | educational_media_id_seq    | sequence | dev_blog_directus
 public | general_information         | table    | dev_blog_directus
 public | general_information_id_seq  | sequence | dev_blog_directus
```

##### `functional_news`
```
functional_news=# \d
                      List of relations
 Schema |        Name        |   Type   |        Owner        
--------+--------------------+----------+---------------------
 public | comments           | table    | functional_news_app
 public | comments_id_seq    | sequence | functional_news_app
 public | submissions        | table    | functional_news_app
 public | submissions_id_seq | sequence | functional_news_app
 public | upvotes            | table    | functional_news_app
 public | upvotes_id_seq     | sequence | functional_news_app
 public | users              | table    | functional_news_app
 public | users_id_seq       | sequence | functional_news_app
(8 rows)
```

### other
- webhook listening for directus cms ping
  - builds dev-blog website and preview version
