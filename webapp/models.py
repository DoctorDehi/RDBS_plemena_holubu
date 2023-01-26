from sqlalchemy import Table, Column, ForeignKey
from sqlalchemy import Integer, String, Text
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import relationship


Base = declarative_base()


plemena_razy = Table(
    "plemena_razy",
    Base.metadata,
    Column("ple", ForeignKey("plemena.id_ple"), primary_key=True),
    Column("raz", ForeignKey("barevne_razy.id_raz"), primary_key=True),
)


class Plemeno(Base):
    __tablename__ = "plemena"

    id_ple = Column(Integer, primary_key=True)
    nazev = Column(String(50), nullable=False)
    sk_nazev = Column(String(50))
    de_nazev = Column(String(50))
    uk_nazev = Column(String(50))
    skupina = Column(Integer, ForeignKey("skupiny.id_sku"), nullable=False)
    velikost = Column(Integer, ForeignKey("velikosti.id_vel"), nullable=False)
    misto_puvodu = Column(Integer, ForeignKey("mista_puvodu.id_mis"))
    krouzek = Column(Integer, nullable=False)
    strucny_popis = Column(Text)

    skupina_r = relationship("Skupina", back_populates="plemena")
    velikost_r = relationship("Velikost", back_populates="plemena")
    misto_puvodu_r = relationship("MistoPuvodu", back_populates="plemena")

    razy = relationship("BarevnyRaz", secondary=plemena_razy)

    def __repr__(self):
        return f"Plemeno(id={self.id_ple!r}, name={self.nazev!r})"


class Skupina(Base):
    __tablename__ = "skupiny"

    id_sku = Column(Integer, primary_key=True)
    nazev = Column(String(50), nullable=False)

    plemena = relationship("Plemeno", back_populates="skupina_r")

    def __repr__(self):
        return f"Skupina(id={self.id_sku!r}, nazev={self.nazev!r})"


class MistoPuvodu(Base):
    __tablename__ = "mista_puvodu"

    id_mis = Column(Integer, primary_key=True)
    nazev = Column(String(50), nullable=False)

    plemena = relationship("Plemeno", back_populates="misto_puvodu_r")


class Velikost(Base):
    __tablename__ = "velikosti"

    id_vel = Column(Integer, primary_key=True)
    nazev = Column(String(50), nullable=False)

    plemena = relationship("Plemeno", back_populates="velikost_r")


class Barva(Base):
    __tablename__ = "barvy"

    id_bar = Column(Integer, primary_key=True)
    nazev = Column(String(50), nullable=False)


class Kresba(Base):
    __tablename__ = "kresby"

    id_kre = Column(Integer, primary_key=True)
    nazev = Column(String(50), nullable=False)


class BarevnyRaz(Base):
    __tablename__ = "barevne_razy"

    id_raz = Column(Integer, primary_key=True)
    bar = Column(Integer, ForeignKey("barvy.id_bar"), nullable=False)
    kre = Column(Integer, ForeignKey("kresby.id_kre"), nullable=False)
