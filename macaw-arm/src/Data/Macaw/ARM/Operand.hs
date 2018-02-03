-- | Instance definitions to assist in extracting Macaw values from instruction operands
--
-- This module is full of orphans, as the definitions of the classes are in a
-- package that cannot depend on the architecture-specific backends.

{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Data.Macaw.ARM.Operand
    (
    )
    where

import qualified Data.Macaw.ARM.ARMReg as Reg
import qualified Data.Macaw.CFG.Core as MC
import qualified Data.Macaw.SemMC.Generator as G
import           Data.Macaw.SemMC.Operands
import           Data.Macaw.Types ( BVType ) -- TypeRepr(..), HasRepr, typeRepr, n32 )
import qualified Data.Parameterized.NatRepr as NR
import           Dismantle.ARM.Operands
import qualified SemMC.ARM as ARM


instance ExtractValue ARM.ARM GPR (BVType 32) where
  extractValue r = G.getRegValue (Reg.ARM_GP r)


instance ToRegister GPR Reg.ARMReg (BVType 32) where
  toRegister = Reg.ARM_GP


instance ExtractValue ARM.ARM (Maybe GPR) (BVType 32) where
  extractValue mgpr =
    case mgpr of
      Just r -> extractValue r
      Nothing -> return $ MC.BVValue NR.knownNat 0


instance ExtractValue arch AddrModeImm12 (BVType 12) where
  extractValue i = return $ MC.BVValue NR.knownNat (toInteger $ addrModeImm12ToBits i)