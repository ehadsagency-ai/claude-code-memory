# 🧠 Context7 MCP Configuration Guide

## Overview

Context7 is a powerful documentation search and persistent memory service that provides access to thousands of library documentations across multiple programming languages and frameworks.

**⚠️ IMPORTANT**: Context7 does NOT have an official MCP server npm package. Use direct API integration instead.

## Configuration Details

### API Credentials
```bash
API_KEY="ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1"
API_URL="https://context7.com/api/v1"
MCP_URL="mcp.context7.com/mcp" # (Note: Not functional as MCP server)
```

### Authentication
All API requests require Bearer token authentication:
```bash
Authorization: Bearer ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1
```

## API Endpoints

### 1. Search Documentation
Search across all available library documentation:

**Endpoint**: `GET /search`

**Example**:
```bash
curl -X GET "https://context7.com/api/v1/search?query=pandas+dataframe" \
  -H "Authorization: Bearer ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1"
```

**Response Format**:
```json
{
  "results": [
    {
      "id": "/pandas/documentation",
      "title": "Pandas",
      "description": "Data analysis library",
      "totalTokens": 150000,
      "totalSnippets": 1200,
      "totalPages": 300,
      "stars": 40000,
      "trustScore": 9.5,
      "versions": []
    }
  ],
  "metadata": {
    "authentication": "free"
  }
}
```

### 2. Get Documentation
Retrieve specific library documentation:

**Endpoint**: `GET /get_docs`

**Example**:
```bash
curl -X GET "https://context7.com/api/v1/get_docs?id=/pandas/documentation" \
  -H "Authorization: Bearer ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1"
```

## Usage Examples

### Python Libraries
```bash
# NumPy arrays
curl -X GET "https://context7.com/api/v1/search?query=numpy+array+operations" \
  -H "Authorization: Bearer ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1"

# Pandas DataFrames
curl -X GET "https://context7.com/api/v1/search?query=pandas+dataframe+merge" \
  -H "Authorization: Bearer ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1"

# Matplotlib visualization
curl -X GET "https://context7.com/api/v1/search?query=matplotlib+pyplot+subplots" \
  -H "Authorization: Bearer ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1"
```

### JavaScript/React
```bash
# React Hooks
curl -X GET "https://context7.com/api/v1/search?query=react+hooks+useState" \
  -H "Authorization: Bearer ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1"

# Next.js routing
curl -X GET "https://context7.com/api/v1/search?query=nextjs+app+router" \
  -H "Authorization: Bearer ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1"
```

### Machine Learning
```bash
# Scikit-learn
curl -X GET "https://context7.com/api/v1/search?query=scikit-learn+random+forest" \
  -H "Authorization: Bearer ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1"

# TensorFlow
curl -X GET "https://context7.com/api/v1/search?query=tensorflow+keras+model" \
  -H "Authorization: Bearer ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1"
```

## Integration with Claude Code

### Method 1: WebFetch Tool
```
Ask Claude: "Use WebFetch to search Context7 for pandas documentation"
```

### Method 2: Bash Tool
```
Ask Claude: "Search Context7 API for React hooks documentation using curl"
```

### Method 3: Custom Agent Integration
Agents can use the Bash tool to make direct API calls:
```python
# In agent system_prompt
"When you need to search for library documentation, use Context7 API:
curl -X GET 'https://context7.com/api/v1/search?query=YOUR_QUERY' \
  -H 'Authorization: Bearer ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1'"
```

## Agent Configuration

The following agents have been configured to use Context7:

### CEO Orchestrator
- **Purpose**: Strategic memory management across all projects
- **Access**: Direct API via Bash/WebFetch tools
- **Use case**: Storing architectural decisions and error patterns

### CRO Research Lead
- **Purpose**: Documentation research and compliance
- **Access**: Direct API via Bash/WebFetch tools
- **Use case**: Finding library documentation and best practices

### Documentation Researcher
- **Purpose**: Deep documentation search and analysis
- **Access**: Direct API via Bash/WebFetch tools
- **Use case**: Comprehensive library research

### MCP Integration Agent
- **Purpose**: External API integrations
- **Access**: Direct API via Bash/WebFetch tools
- **Use case**: Real-time documentation retrieval

## Limitations

1. **No MCP Package**: Context7 does not provide an official `@context7/mcp-server` npm package
2. **API-Only Access**: Must use direct HTTP API calls via WebFetch or Bash curl
3. **Rate Limits**: Check Context7 documentation for current API rate limits
4. **Authentication**: Requires Bearer token for all requests

## Troubleshooting

### Failed MCP Connection
If you see "context7: ✗ Failed to connect" in `claude mcp list`:
- This is expected - Context7 doesn't have an MCP server package
- Use direct API calls instead

### API Key Issues
If authentication fails:
1. Verify API key is correct: `ctx7sk-632fdccd-84cd-47c7-8b58-efa2b07a99a1`
2. Check authorization header format: `Bearer <api_key>`
3. Test with curl directly before using in Claude Code

### Search Returns No Results
If searches return empty results:
1. Simplify your query (use `+` for spaces)
2. Try broader search terms
3. Check if the library is available in Context7's database

## Best Practices

1. **Query Formatting**: Use `+` instead of spaces in URLs
2. **Error Handling**: Always check API response status codes
3. **Caching**: Store frequently accessed documentation locally
4. **Fallback**: Use ref-tools MCP as backup for documentation search

## Security Notes

- API key is stored in environment variables and configuration files
- Never commit API keys to public repositories
- Use `.gitignore` to exclude configuration files with credentials
- Rotate API keys periodically for security

## Additional Resources

- **Context7 Website**: https://context7.com
- **API Documentation**: https://context7.com/api/v1
- **Dashboard**: https://context7.com/dashboard
- **Support**: Contact via Context7 platform

---

**Configuration Date**: 2025-09-29
**Configured By**: Digital Executive Officer (DEO)
**Status**: ✅ Active - Direct API Integration