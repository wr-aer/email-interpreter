resource "aws_resourcegroups_group" "project_resource_group" {
  name = "${var.project_name}-project-resource-group"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "Project",
      "Values": ["${var.project_name}"]
    }
  ]
}
JSON
  }
}
