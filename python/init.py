import matlab
import matlab.engine

eng      = 0
def _init_engine():
    global eng  
    eng     = matlab.engine.start_matlab()
    return eng
def _get_engine():
    global eng
    return eng

def _quit_engine():
    global eng
    eng.quit
    return 1