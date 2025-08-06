# Maintenance GitHub Action V2

This action enables or disables maintenance mode for services using centralized templates from the `teacher-services-cloud` repository.

## Key Features

- **Centralized Templates**: Uses templates from `teacher-services-cloud` repository
- **Simple Customization**: All customization through action inputs (no config files)
- **Automatic Updates**: Template improvements automatically available to all services
- **Backward Compatible**: Easy migration path from v1

## Usage Examples

### Minimal Configuration
```yaml
- name: Enable maintenance
  uses: DFE-Digital/github-actions/maintenance/action-v2@main
  with:
    environment: production
    mode: enable
    docker-repository: myservice-maintenance
    azure-credentials: ${{ secrets.AZURE_CREDENTIALS }}
```

### Standard Configuration
```yaml
- name: Enable maintenance
  uses: DFE-Digital/github-actions/maintenance/action-v2@main
  with:
    environment: production
    mode: enable
    docker-repository: myservice-maintenance
    azure-credentials: ${{ secrets.AZURE_CREDENTIALS }}
    service-name: "Apply for Teacher Training"
    maintenance-message: "We're upgrading our systems to serve you better."
    contact-email: "support@education.gov.uk"
```

### Full Configuration
```yaml
- name: Enable maintenance
  uses: DFE-Digital/github-actions/maintenance/action-v2@main
  with:
    environment: production
    mode: enable
    docker-repository: myservice-maintenance
    azure-credentials: ${{ secrets.AZURE_CREDENTIALS }}
    service-name: "Apply for Teacher Training"
    maintenance-message: "We are performing scheduled maintenance to improve system performance."
    contact-email: "support@apply-for-teacher-training.service.gov.uk"
    estimated-return-time: "15:00 GMT"
    status-page-url: "https://status.education.gov.uk"
    template-ref: "v2.1.0"  # Pin to specific version
```

### Disabling Maintenance
```yaml
- name: Disable maintenance
  uses: DFE-Digital/github-actions/maintenance/action-v2@main
  with:
    environment: production
    mode: disable
    azure-credentials: ${{ secrets.AZURE_CREDENTIALS }}
```

## How It Works

1. **Fetches Templates**: Uses sparse checkout to get maintenance page templates from `teacher-services-cloud`
2. **Applies Customizations**: Replaces placeholders in HTML with your input values
3. **Builds Docker Image**: Creates maintenance page container with customized content
4. **Deploys**: Enables or disables maintenance mode using existing infrastructure

## Migration from V1

### Before (V1)
Each service maintains its own `maintenance_page/` directory with:
- Dockerfile
- nginx.conf
- html/index.html
- All assets and styles

### After (V2)
Services only need to update their workflow file:

```yaml
# Change from:
uses: DFE-Digital/github-actions/maintenance@main

# To:
uses: DFE-Digital/github-actions/maintenance/action-v2@main
with:
  service-name: "Your Service Name"
  maintenance-message: "Your custom message"
  contact-email: "your-support@education.gov.uk"
```

Then remove the local `maintenance_page/` directory - it's no longer needed!

## Template Repository

Templates are maintained at:
```
github.com/DFE-Digital/teacher-services-cloud
└── templates/new_service/maintenance_page/
    ├── Dockerfile
    ├── nginx.conf
    └── html/
        └── index.html
```

To update the templates for all services, make changes in the teacher-services-cloud repository.