# school_management

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## S3 Environment Variables

Add these environment variables to your backend `.env` file for S3 file upload functionality.

### Required Environment Variables

#### Option 1: S3-specific variable names (Recommended)
```env
# S3 Configuration
S3_REGION=ap-south-1
S3_BUCKET_NAME=your-bucket-name
S3_ACCESS_KEY_ID=your-access-key-id
S3_SECRET_ACCESS_KEY=your-secret-access-key

# Optional: Custom public URL (if using CloudFront or custom domain)
S3_PUBLIC_BASE_URL=https://cdn.yourdomain.com
```

#### Option 2: AWS standard variable names (Alternative)
```env
# AWS/S3 Configuration
AWS_REGION=ap-south-1
AWS_S3_BUCKET=your-bucket-name
AWS_ACCESS_KEY_ID=your-access-key-id
AWS_SECRET_ACCESS_KEY=your-secret-access-key

# Optional: Custom public URL (if using CloudFront or custom domain)
S3_PUBLIC_BASE_URL=https://cdn.yourdomain.com
```

### Variable Details

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `S3_REGION` or `AWS_REGION` | No | `ap-south-1` | AWS region where your S3 bucket is located |
| `S3_BUCKET_NAME` or `AWS_S3_BUCKET` | **Yes** | None | Name of your S3 bucket |
| `S3_ACCESS_KEY_ID` or `AWS_ACCESS_KEY_ID` | **Yes** | None | AWS access key ID for authentication |
| `S3_SECRET_ACCESS_KEY` or `AWS_SECRET_ACCESS_KEY` | **Yes** | None | AWS secret access key for authentication |
| `S3_PUBLIC_BASE_URL` | No | Auto-generated | Custom base URL for public file access (e.g., CloudFront distribution URL) |

### Priority Order

The configuration uses the following priority:
1. S3-specific variables (e.g., `S3_REGION`) are checked first
2. AWS standard variables (e.g., `AWS_REGION`) are used as fallback
3. Default values are used if neither is set (only for region)

### Example `.env` Configuration

```env
# Database (existing)
DB_HOST=localhost
DB_USERNAME=root
DB_PASSWORD=yourpassword
DB_NAME=CineMarathi

# JWT (existing)
JWT_SECRET=your-jwt-secret

# S3 Configuration (NEW)
S3_REGION=ap-south-1
S3_BUCKET_NAME=cinemarathi-uploads
S3_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
S3_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

# Optional: If using CloudFront or custom CDN
S3_PUBLIC_BASE_URL=https://d1234567890.cloudfront.net
```

### Security Best Practices

1. **Never commit `.env` file to Git**
   - Add `.env` to your `.gitignore`

2. **Use IAM roles instead of access keys** (for production)
   - If deploying on AWS (EC2, Lambda, etc.), use IAM roles instead of access keys

3. **Restrict IAM permissions**
   - Only grant necessary S3 permissions to the IAM user
   - Use least privilege principle

4. **Rotate credentials regularly**
   - Change access keys periodically for security

5. **Use environment-specific buckets**
   - Use different buckets for development, staging, and production
