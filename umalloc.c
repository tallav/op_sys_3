#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"

// Memory allocator by Kernighan and Ritchie,
// The C programming Language, 2nd ed.  Section 8.7.

// The free storage is kept as a list of free blocks.
// The blocks are kept in order of increasing storage address, 
// and the last block (highest address) points to the first.

typedef long Align;  // for alignment to long boundary

union header { // block header
  struct {
    union header *ptr; // pointer to the next block
    uint size; // block size
  } s;
  Align x; // force alignment of blocks
};

typedef union header Header;

static Header base; // empty list to get started
static Header *freep; // start of free list

// put block ap in free list
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1; // point to block header
  // It scans the free list, starting at freep, looking for the place to insert the free block.
  // This is either between two existing blocks or at one end of the list.
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break; // freed block at start or end of arena
  // In any case, if the block being freed is adjacent to either neighbor, the adjacent blocks are combined.
  if(bp + bp->s.size == p->s.ptr){ // join to upper neighbor
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){ // join to lower neighbor
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
}

// obtains storage from the operating system.
static Header*
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  // system call sbrk(n) returns a pointer to n more bytes of storage. 
  p = sbrk(nu * sizeof(Header));
  if(p == (char*)-1) // sbrk returns -1 if there was no space.
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
  free((void*)(hp + 1));
  return freep;
}

// general-purpose storage allocator
void*
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){ // no free list yet
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  // the free list is scanned until a big-enough block is found
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
	  // If the block is exactly the size requested it is unlinked from the list and returned to the user
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
	  // If the block is too big, it is split, and the proper amount is returned to the user.
	  // the residue remains on the free list
      else {
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
	  // The pointer returned by malloc points at the free space (not at the header itself)
	  // which begins one unit beyond the header.
      return (void*)(p + 1);
    }
	// If no big-enough block is found, another large chunk is obtained from the OS and linked into the free list.
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}

// like malloc but also always allocate exactly 1 page, it will be page-aligned,
// if there is any free memory in the previously allocated page it will skip it.
void* pmalloc(){
	
}

// this function will verify that the address of the pointer has been allocated using pmalloc.
// then it will protect the page, and return 1. return –1 on failure.
int protect_page(void* ap){
	return 0;
}

// this function will attempt to release a protected page that pointed at the argument.
// return –1 on failure, 1 on success.
Int pfree(void* ap){
	return 0;
}
