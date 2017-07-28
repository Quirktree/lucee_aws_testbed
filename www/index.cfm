<cfscript>



  credstash = createObject(
    "java",
    "com.jessecoyle.JCredStash"
  ).init();

  writeDump("Version before: #credstash.getHighestVersion("credential-store", "myapp.db.dev")#");
  credstash.putSecret("credential-store","myapp.db.dev", "updated at #timeFormat(now(), "hh:mm:ss")#", "alias/credstash", nullValue());
  writeDump(credstash.getSecret("credential-store", "myapp.db.dev", nullValue()));
  writeDump("Version after: #credstash.getHighestVersion("credential-store", "myapp.db.dev")#");


  // Using the Java SDK Client with custom credential provider
  s3 = createObject(
    "java",
    "com.amazonaws.services.s3.AmazonS3ClientBuilder"
    // ).defaultClient();
  ).standard()
  //  .withCredentials( Application.creds )
  //  .withRegion( 'us-west-2' )
   .build();

  buckets = s3.listBuckets();

  buckets_iterator = buckets.listIterator();

  while ( buckets_iterator.hasNext() ) {
    bucket = buckets_iterator.next();
    writeDump( bucket.getName() );
  }

</cfscript>
