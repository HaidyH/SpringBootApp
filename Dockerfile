# # Base image
# FROM openjdk:8-jdk

# # Set the working directory
# WORKDIR /app

# # Copy the app's source code to the container
# COPY . /app

# # Set the environment variables
# ENV ANDROID_COMPILE_SDK=30
# ENV ANDROID_BUILD_TOOLS=30.0.3
# ENV ANDROID_SDK_ROOT=/sdk
# ENV PATH=$PATH:/sdk/platform-tools

# # Install dependencies
# RUN apt-get --quiet update --yes
# RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1

# # Download and install Android SDK
# RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip
# RUN unzip -q android-sdk.zip -d /sdk
# RUN rm android-sdk.zip
# RUN yes | sdkmanager --licenses

# # Install Android SDK components
# RUN sdkmanager "platforms;android-$ANDROID_COMPILE_SDK" "build-tools;$ANDROID_BUILD_TOOLS"

# # Build the app
# RUN ./gradlew assembleDebug

# # Expose the necessary ports
# EXPOSE 8080

# # Start the app
# CMD ["./gradlew", "installDebug"]



FROM openjdk:latest
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac Main.java
CMD ["java", "Main"]