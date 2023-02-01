import os
from flask import Flask, render_template, jsonify
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import func, desc, text
from models import *


app = Flask(__name__)


basedir = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://test:testovaci@localhost:5432/cznp_holub'

db = SQLAlchemy(app)



@app.route('/')
def index():
    return render_template('index.html')


@app.route('/plemena')
def seznam_plemen():
    plemena = db.session.query(Plemeno).all()
    return render_template('seznam_plemen.html', plemena=plemena)


@app.route("/plemena/<int:id_ple>")
def plemeno_detail(id_ple):
    plemeno = db.session.query(Plemeno).filter(Plemeno.id_ple==id_ple).one()
    razy = db.session.execute(
        db.select(Barva.nazev, func.array_agg(Kresba.nazev), func.public.colorToCssClass(Barva.nazev)).filter(Plemeno.id_ple == id_ple).join(Plemeno.razy).join(
            BarevnyRaz.barva).join(BarevnyRaz.kresba).group_by(Barva.nazev)).all()
    return render_template("detail_plemene.html", plemeno=plemeno, razy=razy)


# Grafy
@app.route('/grafy/pocty-skupiny')
def graph_count_groups():
    result = db.session.execute(db.select(
        Skupina.nazev.label("nazev"),
        func.count(Plemeno.id_ple).label("pocet"),
    ).join(Plemeno.skupina_r).group_by(Plemeno.skupina, Skupina.nazev).order_by(desc(text("pocet")))).all()

    labels = []
    values = []
    for i in result:
        labels.append(i[0])
        values.append(i[1])

    label = "Počet plemen ve skupině"
    title = "Počty plemen ve skupinách"
    return render_template('bar_chart.html', title=title, label=label, labels=labels, values=values)


@app.route('/grafy/pocty-razy')
def graph_count_razy():
    subq = db.select(
        Plemeno.nazev.label("nazev"),
        func.count(BarevnyRaz.id_raz).label("pocet")
    ).join(Plemeno.razy).group_by(Plemeno.nazev).subquery()
    result = db.session.execute(db.select(func.array_agg(subq.c.nazev), func.array_agg(subq.c.pocet))).all()

    labels = result[0][0]
    values = result[0][1]

    label = "Počet barevných rázů"
    title = "Počty barevných rázů, ve kterých se plemena vyskytují, dle vzorníku"
    return render_template('bar_chart.html', title=title, label=label, labels=labels, values=values)

@app.route('/grafy/pocty-barvy-razy')
def graph_count_barvy_razy():
    result = ...


@app.route('/test')
def test():
    result = db.session.execute(db.select(
        Plemeno.nazev.label("nazev"),
        func.count(BarevnyRaz.id_raz).label("pocet")
    ).join(Plemeno.razy).group_by(Plemeno.nazev)).all()
    result = db.session.execute(db.select(func.public.colorToCssClass(Barva.nazev))).all()
    return (str(result))


if __name__ == '__main__':
    app.run()
