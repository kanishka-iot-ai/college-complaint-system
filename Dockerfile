# ==============================================================================
# Production Dockerfile for College Complaint Management System
# Base Image: Apache Tomcat 9 with Eclipse Temurin OpenJDK 17
# ==============================================================================
FROM tomcat:9.0-jdk17-temurin

# Remove default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/webapps/ROOT.war

# Copy the pre-compiled WAR file as ROOT.war to serve on / (domain root)
COPY target/CollegeComplaintSystem.war /usr/local/tomcat/webapps/ROOT.war

# Environment variables for database connection (can be overridden at runtime)
ENV DB_URL=""
ENV DB_USER="root"
ENV DB_PASSWORD=""

# Expose default port
EXPOSE 8080

# Run Tomcat
CMD ["catalina.sh", "run"]
