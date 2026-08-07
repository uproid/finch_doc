import 'package:finch/mcp.dart';
import 'package:finch_doc/core/data_extractor.dart';

class McpDocController extends McpServerController {
  @override
  void configure(McpBuilder mcp) {
    final docs = Extractor.contents['en']?.contents ?? {};

    docs.forEach((key, doc) {
      final name = key.isEmpty ? 'readme' : key;
      final desc = doc.description.isNotEmpty
          ? doc.description
          : 'No description available.';

      // ── Tool ────────────────────────────────────────────────────────────────
      mcp.tool(
        name: name,
        title: doc.title,
        description: desc,
        outputSchema: ToolSchema(
          type: 'object',
          properties: {
            'text': <String, Object?>{'type': 'string'}
          },
          required: ['text'],
        ),
        handler: (req) async => CallToolResult(
          content: [],
          structuredContent: {'text': doc.md},
        ),
      );

      // ── Resource ─────────────────────────────────────────────────────────────
      mcp.resource(
        name: name,
        uri: rq.url(key),
        title: doc.title,
        description: desc,
        mimeType: 'text/markdown',
        handler: (req) async => ReadResourceResult(
          contents: [
            TextResourceContents(
              text: doc.md,
              uri: rq.url(key),
              mimeType: 'text/markdown',
              $meta: MetaObject(doc.meta.cast()),
            ),
          ],
          $meta: ResultMetaObject(additionalData: {
            ...doc.meta.cast<String, dynamic>(),
            'uri': req.params.uri,
            'url': rq.url(key),
          }),
          ttlMs: 60000,
          cacheScope: CacheScope.public,
        ),
      );

      // ── Prompt ───────────────────────────────────────────────────────────────
      mcp.prompt(
        name: name,
        title: doc.title,
        description: desc,
        handler: (req) async => GetPromptResult(
          description: desc,
          messages: [
            PromptMessage(
              role: Role.assistant,
              content: TextContent(text: doc.md, mimeType: 'text/markdown'),
            ),
          ],
          $meta: ResultMetaObject(additionalData: {
            ...doc.meta.cast<String, dynamic>(),
            'name': req.params.name,
            'url': rq.url(key),
          }),
        ),
      );
    });

    // ── Resource Template ──────────────────────────────────────────────────────
    mcp.resourceTemplate(
      name: 'default',
      uriTemplate: '{+url}',
      title: 'Default Template',
      description: 'A default template for rendering resources.',
    );
  }
}
