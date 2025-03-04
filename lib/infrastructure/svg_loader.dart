import 'dart:convert';

import 'package:aitapp/domain/types/map_shape.dart';
import 'package:aitapp/domain/types/map_shapes.dart';
import 'package:aitapp/utils/convert_css_color.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

class SVGLoader {
  Future<MapShapes> loadSVGMap() async {
    final data = await rootBundle.load('assets/images/map.svg');
    final document = XmlDocument.parse(utf8.decode(data.buffer.asUint8List()));
    final strokeRoot = document.findAllElements('svg').first;
    final result = <String, List<XmlNode>>{};
    _traverseTree(strokeRoot, result);
    final selectableShapes = <MapShape>[];
    final unSelectableShapes = <MapShape>[];
    for (final key in result.keys) {
      if (key != '0') {
        final shape = _parseShapes(result[key]!, int.parse(key));
        selectableShapes.add(shape);
      } else {
        final shape = result[key]!.map((shape) => _parseShapes([shape], null));
        unSelectableShapes.addAll(shape);
      }
    }

    return MapShapes(
      selectableShapes: selectableShapes,
      unSelectableShapes: unSelectableShapes,
    );
  }

  void _traverseTree(XmlNode node, Map<String, List<XmlNode>> result) {
    if (node.nodeType == XmlNodeType.ELEMENT) {
      if (node.children.isNotEmpty) {
        for (final child in node.children) {
          _traverseTree(child, result);
        }
      } else {
        final dataName = node.getAttribute('data-name') ??
            node.parent!.getAttribute('data-name') ??
            '0';
        if (node.getAttribute('data-name') == null) {
          node.setAttribute(
            'data-name',
            dataName,
          );
        }
        result.putIfAbsent(dataName, () => []);
        result[dataName]?.add(node);
      }
    }
  }

  MapShape _parseShapes(List<XmlNode> nodes, int? key) {
    final pathList = <String>[];
    String? strokeWidth;
    String? strokeColor;
    String? fillColor;
    String? colision;
    for (final node in nodes) {
      if (node.getAttribute('is-collision') != null) {
        colision = node.getAttribute('d') ?? '0';
        continue;
      }
      if (node.getAttribute('d') != null) {
        pathList.add(node.getAttribute('d') ?? '0');
      }
      if (node.getAttribute('stroke-width') != null) {
        strokeWidth = node.getAttribute('stroke-width');
      }
      if (node.getAttribute('stroke') != null) {
        strokeColor = node.getAttribute('stroke');
      }
      if (node.getAttribute('fill') != null) {
        fillColor = node.getAttribute('fill');
      }
    }
    final mapShape = MapShape(
      strPathList: pathList,
      strokeColor: strokeColor != null
          ? ConvertHexColor.from(strokeColor)
          : const Color.fromARGB(0, 0, 0, 0),
      fillColor: fillColor != 'none' && fillColor != null
          ? ConvertHexColor.from(fillColor)
          : const Color.fromARGB(0, 0, 0, 0),
      strokeWidth: double.parse(strokeWidth ?? '0.0'),
      strColision: colision,
      id: key,
    );
    return mapShape;
  }
}
