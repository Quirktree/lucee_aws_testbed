component {
  this.name = "Testing AWS";
  this.sessiontype = "j2ee";
  this.javaSettings = {
    loadPaths = ["/opt/lucee/server/lucee-server/context/lib/"],
    loadColdFusionClassPath = true,
    reloadOnChange = false
  };

  function onApplicationStart() {

    var instanceProfileProvider = createObject(
      'java',
      'com.amazonaws.auth.InstanceProfileCredentialsProvider'
    ).init( true ); // provider will refresh credentials asynchronously

    var assumeRoleProvider = createObject(
      'java',
      'com.amazonaws.auth.STSAssumeRoleSessionCredentialsProvider$Builder'
    ).init(
      'arn:aws:iam::719088718005:role/BasicDeveloper',
      '123' // fancy session name
    ).build();


    var providerList = [ instanceProfileProvider, assumeRoleProvider ];

    // createObject(
    //   "java",
    //   "com.amazonaws.auth.AWSCredentialsProviderChain"
    // ).init( providerList );

    return true;
  }
}
