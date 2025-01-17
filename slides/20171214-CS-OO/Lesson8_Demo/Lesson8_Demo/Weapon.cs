﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lesson8_Demo
{
    public abstract class Weapon
    {
        public virtual int GetDamage()
        {
            Random rnd = new Random(Guid.NewGuid().GetHashCode());
            int damage = BaseDamage;
            for (int i = 0; i < DiceNumber; i++)
            {
                damage += rnd.Next(1, DiceSide + 1);
            }
            return damage;
        }

        public abstract string Name { get; }

        protected abstract int BaseDamage { get; }

        protected abstract int DiceNumber { get; }

        protected abstract int DiceSide { get; }
    }

    public class LittleKnife : Weapon
    {
        public override string Name { get => "小刀"; }

        //1d2+1
        protected override int BaseDamage { get => 1; }

        protected override int DiceNumber { get => 1; }

        protected override int DiceSide { get => 2; }
    }

    public class Sword : Weapon
    {
        public override string Name { get => "普通的劍"; }

        //2d3+3
        protected override int BaseDamage { get => 3; }

        protected override int DiceNumber { get => 2; }

        protected override int DiceSide { get => 3; }
    }

    public sealed class Excalibur : Sword
    {
        public override string Name { get => "聖劍！EX．咖哩棒"; }

        //(5d6+7)*3
        public override int GetDamage()
        {
            return base.GetDamage() * 3;
        }

        protected override int BaseDamage { get => 7; }

        protected override int DiceNumber { get => 5; }

        protected override int DiceSide { get => 6; }
    }

    public class DragonBreath : Weapon
    {
        public override string Name { get => "龍之吐息"; }

        //3d5+10
        protected override int BaseDamage { get => 10; }

        protected override int DiceNumber { get => 3; }

        protected override int DiceSide { get => 5; }
    }
}
