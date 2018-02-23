# postfix_to_redis

For test purposes and ease of use the root user is used:
Thus, all the mails send to root@virtual.domain.tld will be stored in REDIS.
In order to retrieve emails from REDIS for specific user use read_from_redis.rb  script :

./read_from_redis.rb -e <...>@virtual.domain.tld



Ruby Gems Required:
redis 
mail


Changes in postfix/main.cf
76c76
< myhostname = virtual.domain.tld
---
> #myhostname = virtual.domain.tld
83c83
< mydomain = domain.tld
---
> #mydomain = domain.tld
98c98
< myorigin = $myhostname
---
> #myorigin = $myhostname
419c419
< home_mailbox = Maildir/
---
> #home_mailbox = Maildir/

copy put_data_to_redis.rb and read_from_redis.rb  to users home directory or any other one.

 set required permissions:
chcon -t postfix_local_exec_t /home/user_name/put_data_to_redis.rb


Configuration change to forward all emails send to specific recipient to ruby script that will store email in Redis 
edit /etc/aliases by adding

user_name: "|/home/user_name/put_data_to_redis.rb"

Reload aliases by running:
newaliases

Restart postfix:
systemctl restart postfix


To send test email:
mail -s "This is the subject" <...>@virtual.domain.tld <<< 'This is the test message'


To check postfix log file:
tail /var/log/maillog

To read all email from Redis for specific recipient use bellow script:
./read_from_redis.rb -e <...>@virtual.domain.tld

For current user:
./read_from_redis.rb -e $USER@virtual.domain.tld

