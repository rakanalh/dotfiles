import readline
import pdb

    
class Config(pdb.DefaultConfig):
    sticky_by_default = True
    
    def setup(self, pdb):
        # make 'l' an alias to 'longlist'
        Pdb = pdb.__class__
        Pdb.do_l = Pdb.do_longlist
        Pdb.do_st = Pdb.do_sticky
