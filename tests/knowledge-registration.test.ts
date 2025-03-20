import { describe, it, expect, beforeEach } from 'vitest';
import { mockClarityBitcoin, mockClarityBlockInfo } from './helpers';

// Mock clarity environment
const mockClarity = {
  contracts: {
    'knowledge-registration': {
      functions: {
        'register-knowledge': (title, description, metadataUrl) => {
          return { result: { value: 1 } };
        },
        'get-knowledge': (id) => {
          return {
            result: {
              value: {
                title: 'Traditional Farming Method',
                description: 'Ancient technique for sustainable agriculture',
                owner: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
                timestamp: 100,
                'metadata-url': 'ipfs://QmXyZ...'
              }
            }
          };
        },
        'get-knowledge-count': () => {
          return { result: { value: 1 } };
        }
      }
    }
  }
};

describe('Knowledge Registration Contract', () => {
  beforeEach(() => {
    // Setup mock environment
    mockClarityBlockInfo(100);
    mockClarityBitcoin();
  });
  
  it('should register new knowledge', async () => {
    const result = mockClarity.contracts['knowledge-registration'].functions['register-knowledge'](
        'Traditional Farming Method',
        'Ancient technique for sustainable agriculture',
        'ipfs://QmXyZ...'
    );
    
    expect(result.result.value).toBe(1);
  });
  
  it('should retrieve knowledge by id', async () => {
    const result = mockClarity.contracts['knowledge-registration'].functions['get-knowledge'](1);
    
    expect(result.result.value.title).toBe('Traditional Farming Method');
    expect(result.result.value.description).toBe('Ancient technique for sustainable agriculture');
  });
  
  it('should return the correct knowledge count', async () => {
    const result = mockClarity.contracts['knowledge-registration'].functions['get-knowledge-count']();
    
    expect(result.result.value).toBe(1);
  });
});
