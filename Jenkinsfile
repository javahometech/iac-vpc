def birdIaCECSStateS3 = "javahome-hari-1234"
def birdIaCECSStateS3Region = "ap-south-1"

properties(
	[parameters(
		[string(defaultValue: 'javahome-hari-1234', 
			description: 'Choose S3 bucket to store state file', 
			name: 'birdIaCECSStateS3', trim: false), 
		 string(defaultValue: 'ap-south-1', 
			description: 'Choose the region for S3 bucket', 
			name: 'birdIaCECSStateS3Region', trim: false)
		])
	]
)

pipeline {
    agent any
	
	environment{
	    PATH = "$PATH:/opt"
    }
  
    stages {
        stage('GHE Clone/Pull') {
            steps {
		    echo params.birdIaCECSStateS3
		    
		    checkout scm
            }
        }
		
		stage('S3-Terraform State'){
			steps {
			   script{
			      makeSureS3BucketExists(birdIaCECSStateS3,birdIaCECSStateS3Region)
			   }
			}
		}
		
		stage('Terraform Init') {
            steps {
				sh """
				    terraform init \
					    -backend-config="bucket=${birdIaCECSStateS3}"
				"""
            }
        }
		
		stage('Terraform Apply - Mirror') {
            steps {
				 script{
				   makeSureWorkspaceExists('mirror')
				 }
				sh """
				    terraform apply  -auto-approve
				"""
            }
        }
		
    }
}

def makeSureS3BucketExists(bucketName,region){
	try{
     sh """
	      aws s3 mb s3://$bucketName --region=${region}
	    """
	}catch(error){
	   echo "INFO - ${bucketName} bucket exists"
	}
}

def makeSureWorkspaceExists(workspace){
  try{
     sh """
	      terraform workspace new ${workspace}
	    """
  }catch(error){
       echo "INFO - ${workspace} exists"
  }finally{
     sh "terraform workspace select ${workspace}"
  }
}
