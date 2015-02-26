# Generated on 2015-02-25 16:08:28.715876
@Server:
172.16.0.53|172.16.0.53:10010

@Table:allsales
s,hash:userid
i,tkey:ptime
i:articleid
f:price
i:refid


@Vector:usersales
s,hash:userid
i,+last:articleid
f,+add:total


