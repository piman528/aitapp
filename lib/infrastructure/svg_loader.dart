import 'dart:convert';

import 'package:aitapp/domain/types/map_shape.dart';
import 'package:aitapp/utils/convert_css_color.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

class SVGLoader {
  Future<List<MapShape>> loadSVGMap() async {
    final data = await rootBundle.load('assets/images/map.svg');
    final document = XmlDocument.parse(utf8.decode(data.buffer.asUint8List()));
    final strokeRoot = document.findAllElements('svg').first;
    final result = <XmlNode>[];
    _traverseTree(strokeRoot, result);
    final loadShapes = <MapShape>[];
    for (final node in result) {
      final data = node.getAttribute('d');
      final strokeWidth = node.getAttribute('stroke-width');
      final strokeColor = node.getAttribute('stroke');
      final fillColor = node.getAttribute('fill');
      if (data != null) {
        final id = int.parse(node.getAttribute('data-name') ?? '0');
        final mapShape = MapShape(
          strPath: data,
          strokeColor: strokeColor != null
              ? ConvertHexColor.from(strokeColor)
              : const Color.fromARGB(0, 0, 0, 0),
          fillColor: fillColor != 'none' && fillColor != null
              ? ConvertHexColor.from(fillColor)
              : const Color.fromARGB(0, 0, 0, 0),
          strokeWidth: double.parse(strokeWidth ?? '0.0'),
          isSelectable: node.parentElement!.parentElement!.getAttribute('id') ==
              'selectable',
          id: id,
        );
        loadShapes.add(mapShape);
      }
    }
    return loadShapes;
  }

  void _traverseTree(XmlNode node, List<XmlNode> result) {
    if (node.children.isNotEmpty) {
      for (final child in node.children) {
        _traverseTree(child, result);
      }
    } else {
      if (node.nodeType == XmlNodeType.ELEMENT) {
        result.add(node);
      }
    }
  }
}
