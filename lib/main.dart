import 'package:flutter/material.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dibuja',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      home: Lienzo(),
    );
  }
}

class Lienzo extends StatefulWidget {
  @override
  _LienzoState createState() => _LienzoState();
}

class _LienzoState extends State<Lienzo> {
  List<Offset> points = <Offset>[];

  @override
  Widget build (BuildContext context){
    final Container lienzoArea = Container(
      margin: EdgeInsets.all(4.0),
      alignment: Alignment.topLeft,
      color: Colors.blueGrey[50],
      child: CustomPaint( painter: Dibuja(points)
      ),
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Dibuja'),
      ),
      body: GestureDetector(
        onPanUpdate: (DragUpdateDetails details){
          setState((){
            RenderBox box =context.findRenderObject();
            Offset point = box.globalToLocal(details.globalPosition);
            point = point.translate(0.0, -(AppBar().preferredSize.height));

            points = List.from(points)..add(point);
          });
        },
        onPanEnd: (DragEndDetails details){
          points.add(null);
        },
        child: lienzoArea,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'limpiar lienzo',
        backgroundColor: Colors.red,
        child: Icon(Icons.refresh),
        onPressed:(){
          setState(()=>points.clear());
        },
      ),
     );
  }
}
class Dibuja extends CustomPainter{
  final List<Offset> points;
  Dibuja(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0
      ..color = Colors.red[400];

    for (int i=0; i< points.length -1 ; i++){
      if (points[i] != null && points[i + 1] !=null){
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Dibuja oldDelegate) {
   return oldDelegate.points != points;
  }

}