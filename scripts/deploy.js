const { exec } = require("child_process");

exec(
  // Run docker build and test
  "docker build -t static-web-app -f .docker/Dockerfile .",
  (error, stdout, stderr) => {
    if (error) {
      console.error(`exec error: ${error}`);
      return;
    }
    console.log(`stdout: ${stdout}`);
    console.error(`stderr: ${stderr}`);

    // Run the Docker container
    exec(
      "docker run --name webapp-container static-web-app",
      (error, stdout, stderr) => {
        if (error) {
          console.error(`exec error: ${error}`);
          return;
        }
        console.log(`stdout: ${stdout}`);
        console.error(`stderr: ${stderr}`);

        // Copy the built app from the Docker container to the host system
        exec(
          "docker cp webapp-container:/app/dist ./dist",
          (error, stdout, stderr) => {
            if (error) {
              console.error(`exec error: ${error}`);
              return;
            }
            console.log(`stdout: ${stdout}`);
            console.error(`stderr: ${stderr}`);
          }
        );
      }
    );

    // Stop the Docker container
    exec("docker stop webapp-container", (error, stdout, stderr) => {
      if (error) {
        console.error(`exec error: ${error}`);
        return;
      }
      console.log(`stdout: ${stdout}`);
      console.error(`stderr: ${stderr}`);
    });

    // Run terraform s3 bucket creation
    exec(
      "terraform apply -target=aws_s3_bucket.bucket -target=aws_s3_bucket_versioning.bucket_versioning -target=aws_s3_bucket_website_configuration.webapp_bucket",
      (error, stdout, stderr) => {
        if (error) {
          console.error(`exec error: ${error}`);
          return;
        }
        console.log(`stdout: ${stdout}`);
        console.error(`stderr: ${stderr}`);

        // CP dist to s3 bucket
        exec(
          "aws s3 cp --recursive ./dist s3://webapp-bucket-terraform",
          (error, stdout, stderr) => {
            if (error) {
              console.error(`exec error: ${error}`);
              return;
            }
            console.log(`stdout: ${stdout}`);
            console.error(`stderr: ${stderr}`);
          }
        );
      }
    );
  }
);
