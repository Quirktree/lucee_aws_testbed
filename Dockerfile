# Create a temporary build container for jcredstash
FROM maven:3.5.0-jdk-8 as builder
ARG GAIA_HOME=/usr/local/gaia/
ARG JCREDSTASH_RELEASE=b6e59c5
ARG JCREDSTASH_JAR=jcredstash-1.4-SNAPSHOT.jar

RUN mkdir -p $GAIA_HOME
WORKDIR $GAIA_HOME

RUN git clone https://github.com/jessecoyle/jcredstash.git $GAIA_HOME && git checkout $JCREDSTASH_RELEASE
COPY ./patch $GAIA_HOME/patch
RUN git apply patch/jcredstash-$JCREDSTASH_RELEASE*.patch
RUN ["mvn","verify","--fail-never"]

# Build the app server container
FROM lucee/lucee51-nginx
ARG SERVER_CONTEXT="/opt/lucee/server/lucee-server/context"
ARG AWS_SDK_URL="https://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip"
ARG BOUNCYCASTLE_URL="https://www.bouncycastle.org/download/bcprov-jdk15on-157.jar"


RUN wget -nv $AWS_SDK_URL -O /root/aws-java-sdk.zip && \
  unzip -j /root/aws-java-sdk.zip "*lib*.jar" \
   -d $SERVER_CONTEXT/lib &&\
  rm /root/aws-java-sdk.zip

RUN wget -nv $BOUNCYCASTLE_URL -O $SERVER_CONTEXT/lib/bcprov.jar

# Copy the results of jcredstash build into server context
COPY --from=builder /usr/local/gaia/target/${JCREDSTASH_JAR} $SERVER_CONTEXT/lib
